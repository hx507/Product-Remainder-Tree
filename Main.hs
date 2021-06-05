module Main where
import           Control.Arrow
import           Numeric
import           System.Environment

extractNum :: [(Integer,String)] -> Integer
extractNum [(x,"")] = x
extractNum _        = 0

padToPowerOfTwo :: Num a => [a]->[a]
padToPowerOfTwo x = x ++ (take (2^((ceiling.(logBase 2).fromIntegral.length) x) - length x) (repeat 1))

halfList :: [a] -> ([a], [a])
halfList xs = splitAt ((length >>> (`div` 2)) xs) xs

-- From Data.Tuple.Extra
-- > both succ (1,2) == (2,3)
both :: (a -> b) -> (a, a) -> (b, b)
both f (x,y) = (f x, f y)

main :: IO ()
main = do
    getArgs >>= (show >>> ("Got arguments: "++) >>> putStrLn)
    args <- getArgs
    case args of
        ["moduli", fname, save_name] -> do
            putStrLn (show fname)
            ns <- ((readFile fname >>= (lines >>> map readHex >>> map extractNum >>> padToPowerOfTwo >>> return))::IO [Integer])
            let product_tree = buildProductTree ns
            (length >>> show >>> ("length: "++) >>> putStrLn) product_tree
            ((take 4) >>> show >>> ("first few: "++) >>> putStrLn) product_tree
            writeFile save_name (show product_tree)
        _ -> putStrLn "Usage: moduli path/to/moduli_file /path/to/results"

buildProductTree :: [Integer] -> [Integer]
buildProductTree [x] = [x]
buildProductTree xs = do
    let previous_layer = (halfList >>> (uncurry (zipWith (*))) >>> buildProductTree) xs -- calculate previous layer of product-modulo tree
    (uncurry (++)) (both (zipWith (\x y -> x `mod` y^2) previous_layer) (halfList xs)) -- calculate modulo as needed
